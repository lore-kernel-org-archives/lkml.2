Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab0EDXhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:37:41 -0400
Received: from claw.goop.org ([74.207.240.146]:41821 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab0EDXhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:37:40 -0400
Message-ID: <4BE0AFC2.2090207@goop.org>
Date: Tue, 04 May 2010 16:37:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 7/8] Add a bootparameter to reserve high linear address
 space.
References: <20060803002510.634721860@xensource.com> <20060803002518.595166293@xensource.com> <19700101001522.GA3999@ucw.cz>
In-Reply-To: <19700101001522.GA3999@ucw.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/1969 04:15 PM, Pavel Machek wrote:
> Dynamically loaded hypervisor? Do we really want to support that?
>   

(Missed this because your datestamp was 1969...)

The idea was that you could boot a guest under VMWare fully virtualized
then switch it to a VMI guest by loading a module.  I don't think it
ever worked out - the transition was too trick to get right (especially
applying all the pvops patching to a live system).

    J
