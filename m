Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2IYIWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:22:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63803 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2IYIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <CACFOYQkXB0Ms-Bah5V6uQpeExbg7V5DOmuxE=XqOVrO76Lm9YA@mail.gmail.com>
References: <CACFOYQkXB0Ms-Bah5V6uQpeExbg7V5DOmuxE=XqOVrO76Lm9YA@mail.gmail.com>
Date: Tue, 25 Sep 2012 16:22:42 +0800
Message-ID: <CACFOYQm08W3fODbUYF51+Aw0x4izqs4-hT8jRDyX-tVnnnUS+A@mail.gmail.com>
Subject: git pull question
From: Zhi-zhou Zhang <etou.zh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today I update my kernel with git pull. Then a ploblem confused me. I
got the below message with git status.
I excuted git checkout master -f and git reset --hard master. The
ploblem is still there. So anyone please help me
to find what's the matter?

 # On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
# modified:   include/linux/netfilter/xt_connmark.h
# modified:   include/linux/netfilter/xt_dscp.h
# modified:   include/linux/netfilter/xt_mark.h
# modified:   include/linux/netfilter/xt_rateest.h
# modified:   include/linux/netfilter/xt_tcpmss.h
# modified:   include/linux/netfilter_ipv4/ipt_ecn.h
# modified:   include/linux/netfilter_ipv4/ipt_ttl.h
# modified:   include/linux/netfilter_ipv6/ip6t_hl.h
# modified:   net/netfilter/xt_dscp.c
# modified:   net/netfilter/xt_hl.c
# modified:   net/netfilter/xt_rateest.c
# modified:   net/netfilter/xt_tcpmss.c
#
no changes added to commit (use "git add" and/or "git commit -a")


--
Regards,
Zhizhou Zhang
