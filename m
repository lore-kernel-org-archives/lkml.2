Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab1JEMbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:31:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525Ab1JEMbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:31:37 -0400
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>
Date: Wed, 05 Oct 2011 14:31:21 +0200
In-Reply-To: <4E8C4C23.8000007@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	  <1317583287-18300-10-git-send-email-glommer@parallels.com>
	 <1317807988.6766.10.camel@twins> <4E8C4C23.8000007@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317817881.6766.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 16:22 +0400, Glauber Costa wrote:
> 
> We should at least sum up se and rt_se, right?

Ah yes indeed.

> Otherwise... I will re-read the code, but from a first sight, I think 
> you are right. 

Good, less hierarchy walks -> *win*
