Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2GBOgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:36:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:40519 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2GBOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:36:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	<87r4syrl4y.fsf@devron.myhome.or.jp>
	<1340997235.9826.7.camel@iscandar.digidescorp.com>
	<87bok1sx6j.fsf@devron.myhome.or.jp>
	<87zk7lribe.fsf@devron.myhome.or.jp>
	<1341234099.1695.13.camel@iscandar.digidescorp.com>
	<87fw9anuwk.fsf@devron.myhome.or.jp>
	<1341237638.1695.16.camel@iscandar.digidescorp.com>
Date: Mon, 02 Jul 2012 23:36:47 +0900
In-Reply-To: <1341237638.1695.16.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 02 Jul 2012 09:00:38 -0500")
Message-ID: <8762a6nsao.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> True, but with the change you suggest we lose the incrementing of 'i',
> which likely would cause an infinite loop for 1:1 Unicode conversions.

You meant, we just have to do

	if (!is_vfat)
        	ptname[i] = ...;
	i++;

or something? I still feel this looks better to indicate, we don't use
ptname in the case of vfat.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
