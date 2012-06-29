Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2F2Sxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:53:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39756 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab2F2Sxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:53:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Fix non-atomic NFS i_pos read
References: <1340990350-9565-1-git-send-email-steve@digidescorp.com>
	<877guqt2kf.fsf@devron.myhome.or.jp>
	<1340993974.9826.4.camel@iscandar.digidescorp.com>
Date: Sat, 30 Jun 2012 03:53:51 +0900
In-Reply-To: <1340993974.9826.4.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Fri, 29 Jun 2012 13:19:34 -0500")
Message-ID: <87395et0e8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> Just curious, this happened on the real system? I recently heard about
>> NFS issue.
> Not that I'm aware of. Can you point me to any discussion of the NFS
> issue? I've spent a lot of time recently studying the FAT NFS
> implementation and come to the conclusion that it is extremely
> vulnerable to inode eviction.  More to follow...

It is true, I also know NFS support of FAT is broken, but I'm not sure
if it was read-only.  Sorry, recent report was by private email, not
public.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
