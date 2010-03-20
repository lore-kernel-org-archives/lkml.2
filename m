Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0CTDAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 23:00:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59202 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0CTDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 23:00:31 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4BA43A4A.4060607@am.sony.com>
Date: Fri, 19 Mar 2010 20:00:26 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ryan Wang <openspace.wang@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does function_graph support x86_32?
References: <5d592f661003170745s4b09f57ao94a9bd9ba7f04bd1@mail.gmail.com> <4BA17A41.2000303@cn.fujitsu.com>
In-Reply-To: <4BA17A41.2000303@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 05:56 PM, Li Zefan wrote:
> Ryan Wang wrote:
>> Does function_graph support x86_32?
>>
> 
> Yes, but you need to disable CONFIG_CC_OPTIMIZE_FOR_SIZE
> 
> config FUNCTION_GRAPH_TRACER
>         bool "Kernel Function Graph Tracer"
>         depends on HAVE_FUNCTION_GRAPH_TRACER
>         depends on FUNCTION_TRACER
>         depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE

I've been bitten by this numerous times.  I most often
use ftrace on ARM, but when I go back to x86, I almost
always go through a sequence of searching for the
function graph tracer in the menus, then realizing it's
completely missing until I disable CC_OPTIMIZE_FOR_SIZE.

Is there any way to have the menu item appear, but be
unsettable unless the SIZE option is disabled?  I'm
not a Kconfig guru...
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

