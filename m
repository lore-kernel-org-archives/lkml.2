Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0JJPfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0JJPfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:35:04 -0400
Message-ID: <4CB1DD1A.5080906@redhat.com>
Date: Sun, 10 Oct 2010 17:34:50 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box>
In-Reply-To: <20101010130842.GE8256@basil.fritz.box>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 03:08 PM, Andi Kleen wrote:
> I did it intentionally not split up because a split up is unlikely
> to be bisectable. I think there is no need for any splitups.

Shrug. The main encryption thread and ESSIV per-cpu are two separate
things from my point of view.

Anyway, the ball is on DM maintainer's playground now.

Milan
