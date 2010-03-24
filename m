Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0CXLj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:39:29 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48016 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab0CXLj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:39:28 -0400
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] Samsung SoCs: CPU detection support (v4)
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 12:39:19 +0100
From: Marc Zyngier <maz@misterjones.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Organization: Metropolis
In-Reply-To: <20100324070943.GA6779@july>
References: <20100324070943.GA6779@july>
Message-ID: <f333d3ab46b3a4d82c3406199326fc81@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: kmpark@infradead.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Mar 2010 16:09:43 +0900, Kyungmin Park <kmpark@infradead.org>
wrote:
> Store the CPU ID to cpu_id variable and use it to detect CPU
> 
> On S3C64XX, Some pheripherals such as OneNAND have different
configuration
> and handle it differently to do this it needs to detect CPU ID.
> 
> Also S5PC1XX is supported.

For the sake of completeness, would you consider adding support for
s5p6440?

        M.
-- 
Who you jivin' with that Cosmik Debris?
