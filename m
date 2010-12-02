Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0LBCSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:18:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0LBCSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:18:45 -0500
Message-ID: <4CF701EE.7090201@kernel.org>
Date: Thu, 02 Dec 2010 10:18:22 +0800
From: Eugene Teo <eugeneteo@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.org>
Subject: CVE tagged Linux kernel git repositories
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have published CVE tagged Linux kernel git repositories for 2.6, 
2.6.32.y and 2.6.36.y. They are tagged with all the security issues 
reported this year.

You can find them at http://git.kernel.org or
http://git.kernel.org/?p=linux/kernel/git/eugeneteo/linux-2.6-cve-tagged.git;a=summary
http://git.kernel.org/?p=linux/kernel/git/eugeneteo/linux-2.6.32.y-cve-tagged.git;a=summary
http://git.kernel.org/?p=linux/kernel/git/eugeneteo/linux-2.6.36.y-cve-tagged.git;a=summary

You can see when the security issues were addressed:
http://git.kernel.org/?p=linux/kernel/git/eugeneteo/linux-2.6-cve-tagged.git;a=tags

You can also search for security fixes by CVE names, e.g. CVE-2010-2943:
http://git.kernel.org/?p=linux/kernel/git/eugeneteo/linux-2.6-cve-tagged.git;a=shortlog;h=refs/tags/CVE-2010-2943

In this example, you will notice that there are two tags of the same CVE 
name, CVE-2010-2943 and CVE-2010-2943.05. That means that there are five 
patches for this CVE name, and you can access them via CVE-2010-2943.01 
to .05.

Hope this is useful!

Thanks, Eugene
