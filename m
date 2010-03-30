Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0C3MO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:14:28 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:45813 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0C3MO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:14:26 -0400
Subject: Re: linux-next: build failure after merge of the slabh tree
From: Jon Masters <jonathan@jonmasters.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jon Masters <jcm@jonmasters.org>
In-Reply-To: <20100329154208.009a8ae2.sfr@canb.auug.org.au>
References: <20100329154208.009a8ae2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 30 Mar 2010 08:14:15 -0400
Message-ID: <1269951255.4605.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you remove the hwlat tree for the moment? I'm reworking it to use a
newer mechanism and will then repost a more generic version.

Jon.


