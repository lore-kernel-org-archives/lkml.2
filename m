Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1FGHDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:03:24 -0400
Received: from smtp.turknetserver.com ([193.192.122.40]:34851 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299Ab1FGHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:03:23 -0400
Message-ID: <4DEDCCFF.10801@turknetserver.com>
Date: Tue, 07 Jun 2011 10:02:23 +0300
From: Tarkan Erimer <tarkan@turknetserver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: david@lang.hm, Alessandro Suardi <alessandro.suardi@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc2
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com> <BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com> <BANLkTim1ms9ND6evpDVPFRrJBNffMr4KNg@mail.gmail.com> <alpine.DEB.2.02.1106061308590.25491@asgard.lang.hm> <81e5df54-4987-40ba-9333-79665efda719@email.android.com>
In-Reply-To: <81e5df54-4987-40ba-9333-79665efda719@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 09:22 AM, Linus Torvalds wrote:
> I suspect not a lot of people actually use the tarballs these days. 
> It's just much more convenient to get the tree with git. 


I always use tarballs instead of git. Because; I have several Linux 
boxes and just one time I download the kernel tarball then spreading it 
with scp to other Linux boxes easily. Otherwise, I have to prepare a 
tarball by myself to distribute it which is a time waste and 
unpractical. Also, getting the whole 700-800 MB of kernel tree with git 
is not very Internet bandwidth (Consider that in some ISPs and 
countries, Internet usage is limited by monthly quotas.) friendly.

BTW, I'm eagerly waiting to test out the latest 3.0-rc2 when the 
corrected tarballs uploaded to kernel.org :-)

Tarkan
