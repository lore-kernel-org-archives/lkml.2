Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2E3LYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:24:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2E3LYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:24:39 -0400
Message-ID: <1338377072.26856.263.camel@twins>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct
 stats
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 13:24:32 +0200
In-Reply-To: <4FC5FA20.50301@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	   <1338371317-5980-4-git-send-email-glommer@parallels.com>
	  <1338374041.26856.241.camel@twins> <4FC5F7A0.2000201@parallels.com>
	 <1338374628.26856.244.camel@twins> <4FC5FA20.50301@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:44 +0400, Glauber Costa wrote:
> But I don't really parse what you mean by "make the files go away". We 
> have just one file, with multiple entries. The entries are in key:value 
> form, so I don't see a huge problem in having some entries disappearing.
> 
> As a matter of fact, this is exactly what happens in /proc/stat when you 
> offline a cpu: the correspondent line will stop showing up.

Oh, I thought you had a file per cpu.

If you have content per cpu, this all might become a problem with 4096
cpus, that's bound to overflow the page of output space?
