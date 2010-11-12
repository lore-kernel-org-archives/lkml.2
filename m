Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0KLD0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:26:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:13789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0KLD0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:26:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,186,1288594800"; 
   d="scan'208";a="676742319"
Message-ID: <4CDCB3C9.8040303@linux.intel.com>
Date: Thu, 11 Nov 2010 19:26:01 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave@sr71.net>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][BUG FIX] leds: Fix bug with reading NAS SS4200 dmi code
References: <1289529278.12418.391.camel@gandalf.stny.rr.com>
In-Reply-To: <1289529278.12418.391.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 6:34 PM, Steven Rostedt wrote:
> Found that the nas_led_whitelist dmi_system_id structure array had no
> NULL end delimiter, causing the dmi_check_system() loop to read an
> undefined entry.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

