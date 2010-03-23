Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0CWMCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:02:11 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:58082 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0CWMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:02:09 -0400
Message-ID: <4BA8ADB8.1030802@ladisch.de>
Date: Tue, 23 Mar 2010 13:02:00 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David R <david@unsolicited.net>
CC: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc2 - crash on shutdown
References: <20100323090206.33932wop73sdefm6@unsolicited.net>
In-Reply-To: <20100323090206.33932wop73sdefm6@unsolicited.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David R wrote:
> I recently upgraded my kernel to the .34 rc, and I'm getting the  
> following crash on shutdown (see attached console image)

Mee too, also in amd_pmu_cpu_offline().

The only pointer access in this function is cpuhw->amd_nb, but
I don't see any obvious bugs.


Regards,
Clemens
