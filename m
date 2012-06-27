Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2F0EYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:24:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62260 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2F0EYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:24:36 -0400
Date: Tue, 26 Jun 2012 21:24:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] bind the memory device when the driver is being
 loaded
In-Reply-To: <4FE97F34.9090209@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262123550.24245@chino.kir.corp.google.com>
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97F34.9090209@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Wen Congyang wrote:

> We introduce acpi_hotmem_initialized to avoid strange add_memory fail message.
> The stranged add_memory fail message is printed in register_memory_resource().
> We have removed this message in the previous patch, so we can remove
> it(it is very useful to the next patch).
> 

I don't think you can legitimately remove that message, see my comment in 
the previous patch.  There are many callers to add_memory() and it seems 
like this workaround solves most of the pain for acpi, so maybe we can 
just live with it?
