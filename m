Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2IRLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:34:47 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:60268
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757441Ab2IRLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:34:46 -0400
Message-ID: <50585C41.1050704@mimc.co.uk>
Date: Tue, 18 Sep 2012 12:34:25 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 0.5sec delay when ttyO0 is enabled
References: <50584F90.2000606@mimc.co.uk>
In-Reply-To: <50584F90.2000606@mimc.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/12 11:40, Mark Jackson wrote:
> I'm using a BeagleBone, and the linux kernel from Koen Kooi (https://github.com/koenkooi/linux.git).
> 
> I have noticed there is a 0.5sec delay between OMAP UART0 being initialised and the console being
> enabled.

It is, of course, when the printk() messages are processed and dumped to the console.

If I boot with the "quiet" flag, the delay is magically gone.

Apologies for the noise.

