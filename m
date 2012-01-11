Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2AKDd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:33:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45469 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2AKDd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:33:26 -0500
Message-ID: <4F0D02FE.5040101@gmail.com>
Date: Wed, 11 Jan 2012 11:33:18 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org
Subject: [GIT PULL v2] kmap_atomic changes for 3.3
References: <CA+55aFzQrdFP3Sie2ug8uicNyqpD2mYEedj8srgcphfM2rP8JQ@mail.gmail.com> <4F051210.50300@gmail.com>
In-Reply-To: <4F051210.50300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

This is V2 of my pull request, I resolved the conflicts with hv driver, 
and rebased it to your latest tree. The tree is still at:

   git://github.com/congwang/linux.git kmap_atomic


Is there anything else prevent you from pulling this? I am sorry that I 
don't have a signed gpg key as I am not a maintainer, I think my changes 
are easy to verify as they are all cleanups.

Thanks!
