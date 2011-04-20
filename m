Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1DTN2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:28:43 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:45282 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1DTN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:28:42 -0400
Message-ID: <4DAEDFEB.20908@ladisch.de>
Date: Wed, 20 Apr 2011 15:30:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: rwhitton@iee.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
References: <42558.1303286300@jupiter.eclipse.co.uk>
In-Reply-To: <42558.1303286300@jupiter.eclipse.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Whitton wrote:
> I have a home grown module that performs background memory scrubbing
> to eliminate single bit memory errors before they become a problem.
> ... it is specifically targeted at the AMD64 PC architecture

Then why don't you use the memory controller's automatic background
memory scrubbing support?  Doesn't your BIOS have this option?


Regards,
Clemens
