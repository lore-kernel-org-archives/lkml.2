Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2A3RFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:05:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2A3RFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:05:11 -0500
Message-ID: <4F26CDF3.5080606@canonical.com>
Date: Mon, 30 Jan 2012 18:05:55 +0100
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Jussi Pakkanen <jussi.pakkanen@canonical.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Document the device properties
References: <1327912546-16960-1-git-send-email-rydberg@euromail.se> <4F268BCC.4000008@canonical.com>
In-Reply-To: <4F268BCC.4000008@canonical.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 01:23 PM, Jussi Pakkanen wrote:
> On 01/30/2012 10:35 AM, Henrik Rydberg wrote:
>> +INPUT_PROP_SEMI_MT:
>> +------------------
>> +Some touchpads, most common between 2008 and 2011, can detect the presence
>> +of multiple contacts without resolving the individual positions; only the
>> +number of contacts and the corresponding bounding box is known. For such
>> +touchpads, the semi-mt property should be set.
> 
> A "corresponding bounding box" usually means "a bounding box that 
> contains all touches on the touchpad". I've been told (though I have not 
> checked it myself) that there are devices that don't do this. They only 
> report a bounding box for some subset of touches. If this is the case, 
> it should be documented here.

Yeah, I thought Henrik's definition was correct for a long time, but
when Derek Foreman (I think) proposed some patches for the latest
synaptics devices I took a closer look at my semi-mt synaptics trackpad.
The coordinates it gave were locations based on two of the touches. When
three touches are on the touchpad, it gave a bounding box of two of the
touches, and there's no way to tell which two.

-- Chase

