Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0KEUyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:54:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55335 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0KEUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=id5+VkMpg8WzsEBzR8BAkSj+lswU353Jf4Fj/mq5Ux5cYAvBsk9cbRM6VL1dz3Mvx8
         ifgBrTXAdZtVacPI0JP0aY6gEYGZoM3FvPLJ+wLh+qbFiEs8XVsPAnGOSrtgB+GAC1Jg
         TCEO5SFacmjgopGBJPKcNqaaBhZsjdkewZ48E=
Subject: Re: OOM when adding ipv6 route:  How to make available more
 per-cpu memory?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <4CD46892.6050408@candelatech.com>
References: <4CD43C87.5040403@candelatech.com>
	 <1288980361.2882.1070.camel@edumazet-laptop>
	 <4CD449A5.5070305@candelatech.com>
	 <1288988403.2665.268.camel@edumazet-laptop>
	 <4CD46892.6050408@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 21:53:54 +0100
Message-ID: <1288990434.2665.376.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 13:26 -0700, Ben Greear a écrit :

> 
> I was also wondering if it would make sense to allow one to disable
> the snmp stats for ipv6?  I don't think I have any use for those
> stats anyway..
> 

I agree. IPV6 have per device SNMP fields, percpu... thats probably not
needed.

We have many SNMP fields that could avoid being percpu, even for ipv4.



