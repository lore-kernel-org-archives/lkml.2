Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0CRAzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:55:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0CRAzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:55:36 -0400
Message-ID: <4BA17A41.2000303@cn.fujitsu.com>
Date: Thu, 18 Mar 2010 08:56:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ryan Wang <openspace.wang@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Does function_graph support x86_32?
References: <5d592f661003170745s4b09f57ao94a9bd9ba7f04bd1@mail.gmail.com>
In-Reply-To: <5d592f661003170745s4b09f57ao94a9bd9ba7f04bd1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Wang wrote:
> Does function_graph support x86_32?
> 

Yes, but you need to disable CONFIG_CC_OPTIMIZE_FOR_SIZE

config FUNCTION_GRAPH_TRACER
        bool "Kernel Function Graph Tracer"
        depends on HAVE_FUNCTION_GRAPH_TRACER
        depends on FUNCTION_TRACER
        depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE

