Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab2F0ENA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:13:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41476 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2F0EM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:12:58 -0400
Date: Tue, 26 Jun 2012 21:12:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 2/8] free memory device if acpi_memory_enable_device()
 failed
In-Reply-To: <4FE97EA5.9010904@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262112430.24245@chino.kir.corp.google.com>
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97EA5.9010904@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Wen Congyang wrote:

> If acpi_memory_enable_device() fails, acpi_memory_enable_device() will
> return a non-zero value, which means we fail to bind the memory device
> to this driver. So we should free memory device before acpi_memory_device_add()
> returns.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
