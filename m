Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0LEII6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 03:08:58 -0500
Received: from solo.fdn.fr ([80.67.169.19]:45296 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab0LEII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 03:08:57 -0500
Date: Sun, 5 Dec 2010 09:08:55 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Eric Smith <eric@brouhaha.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org
Subject: Re: mmap to address zero with MAP_FIXED returns ENOPERM for non-root users?
Message-ID: <20101205080855.GI8820@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Eric Smith <eric@brouhaha.com>, Kyle Moffett <kyle@moffetthome.net>,
	linux-kernel@vger.kernel.org
References: <4CFB33DA.1070306@brouhaha.com> <AANLkTikPESSNMRQ+WbzpLoRyhhK1UQRvnB5ifpUp+cnk@mail.gmail.com> <4CFB4386.3010806@brouhaha.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CFB4386.3010806@brouhaha.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Smith, le Sat 04 Dec 2010 23:47:18 -0800, a écrit :
> I'm curious, though.  How likely are exploits where I can trick the 
> kernel into calling a function at 0 in my virtual address space, but not 
> trick it into calling a function at some non-zero address of my choosing?

NULL pointers are everywhere in function pointers structures & such.

About translation, maybe you could use an LDT entry to make the
processor do the translation? (additional 1-byte fs: prefix).

Samuel
