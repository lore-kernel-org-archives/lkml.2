Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0IJQTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:19:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0IJQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:19:32 -0400
Date: Fri, 10 Sep 2010 18:19:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100910181929.4f35ab7c@basil.nowhere.org>
In-Reply-To: <20100910160211.GH4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-5-git-send-email-ying.huang@intel.com>
	<20100910160211.GH4879@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am grasping for straws here, but is there a register that APEI/HEST
> can poke to see if it generated the NMI?

HEST knows this yes.

But this is not about HEST errors, but about those without HEST
handling.

-Andi

