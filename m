Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0JJQmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab0JJQl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:41:59 -0400
Message-ID: <4CB1ECCA.8040801@redhat.com>
Date: Sun, 10 Oct 2010 18:41:46 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>
In-Reply-To: <20101010162257.GA1272@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 06:22 PM, Mike Snitzer wrote:
> If you feel you shouldn't be doing any more to your split patches then
> I'll review all of this closer tomorrow.

I think there was small bugfix in my patchset (some missing free in error path)
and I change to use generic per-cpu IV struct (not ESSIV only) -
see patch already sent here https://www.redhat.com/archives/dm-devel/2010-July/msg00118.html

Others are just small code shuffle changes (which I know agk is doing to all patches;-)

I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).

Milan
