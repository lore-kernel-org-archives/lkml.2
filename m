Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1BLSGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:06:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40048 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1BLSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AuBapCK4aQpTKDhVwp6FkiJ/XPgHkkPwd0taNWfKfOAsmPjl1KIzIjxieokKMG85up
         1DgoYMbjRejLKrbILjT97q2RlRXA+JveYkGJKzIbYs3O+5YFADtYFOL8FrSQUtOS9hwL
         Xvtta5j7y+ktfzEC2x/CmUsH5Qlay0JVGrbtE=
MIME-Version: 1.0
In-Reply-To: <4D56CB9F.8030909@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-3-git-send-email-tj@kernel.org>
	<4D56C79B.2060201@kernel.org>
	<AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
	<4D56CB9F.8030909@kernel.org>
Date: Sat, 12 Feb 2011 19:06:32 +0100
X-Google-Sender-Auth: EE_rpl1IhvPVoCiZbgwsgKaTHKc
Message-ID: <AANLkTimAceZOxWQq03QqhXhQ42r2jw6MQYA9Vc2XQo5B@mail.gmail.com>
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 7:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> no. if the node only have hotplug mem.
> then nd->start and nd->end will be set to that hot plug range.
> and old code does not clear nodes_parsed...

Eh?  The oldnode thing will restore the node to initial state thus
fulfilling the node empty condition.  Am I missing something?

-- 
tejun
