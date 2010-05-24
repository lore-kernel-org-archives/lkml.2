Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab0EXEdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 00:33:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:36042 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0EXEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 00:33:14 -0400
Date: Mon, 24 May 2010 07:32:24 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100524043224.GA31700@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1274482015-30899-1-git-send-email-arve@android.com>
 <201005240246.55043.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201005240246.55043.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 May 2010 04:31:54.0286 (UTC) FILETIME=[0992BCE0:01CAFAFA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 02:46:54AM +0200, ext Rafael J. Wysocki wrote:
>On Saturday 22 May 2010, Arve Hjønnevåg wrote:
>> This patch series adds a suspend-block api that provides the same
>> functionality as the android wakelock api. This version adds a
>> delay before suspending again if no suspend blockers were used
>> during the last suspend attempt.
>
>Patches [1-6/8] applied to suspend-2.6/linux-next

funny thing is that even without sorting out the concerns plenty of 
developers had on the other thread, this series is still taken. What's 
the point in dicussing/reviewing the patches then ?

-- 
balbi

DefectiveByDesign.org
