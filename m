Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1CINB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:01:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:53447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CINB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:01:27 -0500
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
In-Reply-To: <1299665998.2308.2753.camel@twins>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 14:01:14 +0100
Message-ID: <1299675674.2308.2924.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 11:19 +0100, Peter Zijlstra wrote:
> No, the domain stuff is good, we allocate new domains and have a
> synchronize_sched() between us installing the new ones and freeing the
> old ones. 

Gah, if only..
