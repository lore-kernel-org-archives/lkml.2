Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423586Ab2KOCcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:32:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423500Ab2KOCcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:32:00 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tLo115Q3hQoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Y-cmGfREMhoA:10 a=n-3_FBgNVrH6sAbhJUcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352946719.18025.89.camel@gandalf.local.home>
Subject: Re: [PATCH 1/4] kernelshark: Fix bug with Plot CPU filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Date: Wed, 14 Nov 2012 21:31:59 -0500
In-Reply-To: <CAJL_ekuL2NjA50eZ-anDefwjAbLBKignXxUvyEPVZvUag5W=Ng@mail.gmail.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
	 <CAJL_ekuL2NjA50eZ-anDefwjAbLBKignXxUvyEPVZvUag5W=Ng@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:52 -0800, David Sharp wrote:
> sorry for the dups... typoed Steve's domain.
> 

I applied and pushed out patches 1,3 and 4. I already commented on why I
neglected patch 2.

-- Steve


