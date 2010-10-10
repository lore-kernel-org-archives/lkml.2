Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0JJMyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0JJMyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:54:07 -0400
Message-ID: <4CB1B762.90900@redhat.com>
Date: Sun, 10 Oct 2010 14:53:54 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com>
In-Reply-To: <4CB1B3B9.4030205@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 02:38 PM, Milan Broz wrote:

> is there some change in your new version?
Of course I mean except the changes you mentioned which are easy
to change in my patchset:-)

(There was requirement from agk to have several simple
bisectable patches.)
 
> Can I send this to dm-devel instead? 
(I mean with the v3 CPU intensive workqueue changes of course)

In any case, it should be merged ASAP
to allow more people to test it.

Milan
