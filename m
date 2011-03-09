Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1CIE2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:28:24 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:50587 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1CIE2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:28:21 -0500
Subject: Re: [PATCH 4/5] avr32: Fix .size directive for cpu_enter_idle
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299630756.4146.25.camel@localhost>
References: <1299630111.4146.15.camel@localhost>
	 <1299630756.4146.25.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 08 Mar 2011 18:28:04 -1000
Message-ID: <1299644884.3121.0.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2011 04:28:09.0133 (UTC) FILETIME=[64C0DDD0:01CBDE12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 00:32 +0000, Ben Hutchings wrote: 
> gas used to accept (and ignore?) .size directives which referred to
> undefined symbols, as this does.  In binutils 2.21 these are treated
> as errors.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

