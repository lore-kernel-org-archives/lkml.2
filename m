Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1ERH7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:59:30 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:46933 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab1ERH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:59:29 -0400
Message-ID: <4DD37CF0.8070703@ladisch.de>
Date: Wed, 18 May 2011 10:01:52 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Monica Puig-Pey <puigpeym@unican.es>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to establish a priority to an interrupt handler
References: <4DD2614A.4060003@unican.es>
In-Reply-To: <4DD2614A.4060003@unican.es>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monica Puig-Pey wrote:
> I'm developing a PCI device driver using hardware interrupts.
> I would like to give a priority chosen by me to my IRQ handler,

Please note that
1) priorities are relative to the other priorites currently in use,
   so assigning a fixed priority does not make sense unless you know
   all the other priorites; and
2) it is the job of the administrator, not of the driver writer, to
   determine which device gets the highest priority.


Regards,
Clemens
