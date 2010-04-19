Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0DSM5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:57:17 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3392 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab0DSM5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:57:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [regression,bisected] Missing boot messages with VESAFB after VT initialization
Date: Mon, 19 Apr 2010 14:57:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
References: <201004171718.55867.elendil@planet.nl> <1271625028.19111.0.camel@t60prh> <201004191403.09593.elendil@planet.nl>
In-Reply-To: <201004191403.09593.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004191457.14202.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2010 12:57:14.0349 (UTC) FILETIME=[D547F1D0:01CADFBF]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Frans Pop wrote:
> On Sunday 18 April 2010, Dave Airlie wrote:
> > On Sat, 2010-04-17 at 17:18 +0200, Frans Pop wrote:
> > > I've bisected this to the following commit:
> > >    commit 477346ff74f4c2aed50e8a0db96a61069f3e5b80
> > >    Author: Dave Airlie <airlied@redhat.com>
> > >    Date:   Thu Jan 7 17:04:54 2010 +1000
> > >        x86-64: Allow fbdev primary video code

Hmm. A straight revert of that commit on top of -rc4 does not fix the 
problem. I'll investigate a bit more.
