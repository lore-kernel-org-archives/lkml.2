Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2F2UJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:09:45 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39776 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2F2UJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:09:44 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	<87r4syrl4y.fsf@devron.myhome.or.jp>
	<1340997235.9826.7.camel@iscandar.digidescorp.com>
	<87bok1sx6j.fsf@devron.myhome.or.jp>
Date: Sat, 30 Jun 2012 05:09:41 +0900
In-Reply-To: <87bok1sx6j.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sat, 30 Jun 2012 05:03:16 +0900")
Message-ID: <87zk7lribe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>
> 			if (is_vfat)
> 				ptname[i++] = fat_tolower(!nocase, c);

Of course, if (!is_vfat). Sorry.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
