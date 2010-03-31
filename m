Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0CaKvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:51:25 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40625 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0CaKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:51:23 -0400
Message-ID: <4BB3291F.2070402@s5r6.in-berlin.de>
Date: Wed, 31 Mar 2010 12:51:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> Also, the help text for the item makes little sense to a non-expert in 
> this area:

I too noticed this absolutely catastrophic "help" text but forgot to
send a bug report.

Either this option can be explained and the text fixed, or it cannot be
explained and shouldn't be an option in the first place.
-- 
Stefan Richter
-=====-==-=- --== =====
http://arcgraph.de/sr/
