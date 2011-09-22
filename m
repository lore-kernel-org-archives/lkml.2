Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab1IVPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:11:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1IVPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:11:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110920172930.GA5318@linux.vnet.ibm.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	<1316030695-19826-2-git-send-email-glommer@parallels.com>
	<1316448186.1511.19.camel@twins>
	<4E776937.1070108@parallels.com>
	<1316449160.6091.5.camel@twins>
	<4E776E36.6040906@parallels.com>
	<1316450385.6091.9.camel@twins>
	<4E7770BD.6050902@parallels.com>
	<1316457653.6091.16.camel@twins>
	<20110920172930.GA5318@linux.vnet.ibm.com>
Date: Thu, 22 Sep 2011 20:41:13 +0530
Message-ID: <CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Balbir Singh <bsingharora@gmail.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:59 PM, Srivatsa Vaddagiri
<vatsa@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-19 20:40:53]:
>
>> > Note I was talking about cpuusage. Well, in this case, I myself fail
>> > to see the value of the whole cpuusage thing...
>
> If I recall, cpuacct was prototyped by Paul Menage (and later modified
> by Balbir) as a way to demonstrate cgroup controller ..It was one
> of those "first" cgroups controllers written to demonstrate how cgroups worked.
>
> With regard to its value, it does provide a handy interface to measure
> cpu utilization of cgroups (vs having to manually sum up task's
> utilization) and afaik libvirt makes use of it (although I
> don't think anyone reads it at "high" frequency).
>

Android makes heavy use of cpuacct as well. We invented it to do cpu
accounting independent of control

Balbir
