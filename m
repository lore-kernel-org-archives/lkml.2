Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1GMQpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab1GMQpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:45:38 -0400
Date: Wed, 13 Jul 2011 12:45:30 -0400
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Underclock checks
Message-ID: <20110713164529.GA1652@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
	Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <1310114243.2940.3.camel@phoenix>
 <4E1B745A.5000802@interia.pl>
 <4E1B8404.1050909@interia.pl>
 <20110711232517.GC20367@redhat.com>
 <4E1C7D96.1030500@interia.pl>
 <4E1DCA76.7090809@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1DCA76.7090809@interia.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 05:40:22PM +0100, Rafał Bilski wrote:
 > 
 > >Some systems are using 1.2GHz@844mV processors running at 600MHz@796mV.
 > OK. That's strange. It is 1,2GHz system. Can both ACPI p-states and "e_powersaver"
 > drivers be running at the same time? 

no

 > Can BIOS change processor frequencies without
 > Linux knowing and without p-states driver loaded?

yes. Usually via SMI. some laptops do this when switching between power/battery,
and/or when overheating.

cpufreq usually detects when this happens and logs messages.

	Dave

