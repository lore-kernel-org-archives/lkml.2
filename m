Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2DWPsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:48:23 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:44055 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752330Ab2DWPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:48:21 -0400
Message-ID: <4F9579E4.2000701@xenotime.net>
Date: Mon, 23 Apr 2012 08:48:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Adds Kconfig option for Cross Memory Attach
References: <20120423134243.5ac73596@Gantu>
In-Reply-To: <20120423134243.5ac73596@Gantu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 09:12 PM, Christopher Yeoh wrote:

> Hi Andrew,
> 
> Attached is a patch which you asked for a while back which adds a
> Kconfig option to allow people who don't want cross memory attach to not
> have it included in their build.


and it shouldn't be default y.

Linus has written a diatribe on [not] making new options
default to y.

-- 
~Randy
