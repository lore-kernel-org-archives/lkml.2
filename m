Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2AIVVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:21:34 -0500
Received: from solo.fdn.fr ([80.67.169.19]:47787 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab2AIVV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:21:28 -0500
Date: Mon, 9 Jan 2012 22:21:25 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Multiple consoles
Message-ID: <20120109212125.GO4266@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Phillip Susi <psusi@cfl.rr.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <4F0B5808.2010900@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F0B5808.2010900@cfl.rr.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi, le Mon 09 Jan 2012 16:11:36 -0500, a écrit :
> Does this make sense or am I missing something?

It used to be planned, but nobody took the job, because X doesn't need
this (see option -sharevts).

Samuel
