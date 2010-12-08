Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0LHXbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:31:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab0LHXbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LfXSqHlxev4EsuVBc5w1QBDebSMPtLzpqlI3ABqGcUNHYxNkBG57pfB4ezSOvZfb+R
         7wuDJxkWJWYdIgym+W2EhLGbprhwh67E1gO5SCZGUJ8tf8CxZvUPZIoGMUA7OBP8kJi/
         ZSpk9q/GhhqZoKbVHxRnz5vdw4KZVtRiYaw/A=
MIME-Version: 1.0
In-Reply-To: <4CFFD11D.4070107@euromail.se>
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
	<4CFFC45C.2040107@canonical.com>
	<20101208180521.GA31522@core.coreip.homeip.net>
	<AANLkTinKVcc3KA3S_7-vwQWtDuUFZ2LSmjgrCrZXcRw5@mail.gmail.com>
	<4CFFD11D.4070107@euromail.se>
Date: Wed, 8 Dec 2010 15:31:12 -0800
Message-ID: <AANLkTinGhQC59jqdyJkVLs+mL9BydZp8gGi7c4XO_CL4@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add hovering distance axis
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 10:40 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On 12/08/2010 07:20 PM, Ping Cheng wrote:
>>
>> ABS_DISTANCE is used in wacom driver as the distance between the tool
>> tip and the tablet.
>
>
> Thanks for the confirmation. While at it, what are the units for the distance,
> for instance for the Cintiq?

mm? I am not so sure. It is a rough count of how far the tool is away
from the tablet.

Ping
