Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1LSPwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:52:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:43609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1LSPwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:52:04 -0500
Message-ID: <1324309908.24621.16.camel@twins>
Subject: Re: [RFC PATCH 4/4] sched:Implement set_gang_buddy
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 16:51:48 +0100
In-Reply-To: <20111219083504.32311.85836.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	 <20111219083504.32311.85836.stgit@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 14:05 +0530, Nikunj A. Dadhania wrote:
> +       /*
> +        * Gang buddy, lets be unfair here
> +        */ 

And why would you think that's an option?
