Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0KZUua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 15:50:30 -0500
Received: from mail.solarflare.com ([216.237.3.220]:24755 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0KZUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 15:50:28 -0500
Subject: Re: [PATCH 3/5] HID: roccat: declaring meaning of pack pragma
 usage in driver headers
From: Ben Hutchings <bhutchings@solarflare.com>
To: erazor_de@users.sourceforge.net
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1290801456.18750.164.camel@neuromancer>
References: <1290801456.18750.164.camel@neuromancer>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 26 Nov 2010 20:50:16 +0000
Message-ID: <1290804616.3051.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2010 20:50:24.0385 (UTC) FILETIME=[8C5A6710:01CB8DAB]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17790.005
X-TM-AS-Result: No--14.451200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 20:57 +0100, Stefan Achatz wrote:
> Using pack pragma to prevent padding bytes in binary data structures
> used for hardware communication. Explanation of these pragmas was requested.
[...]

It would be clearer to use the '__packed' macro after each structure
definition instead of using this awful Microsoft extension.

Ben. 

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

