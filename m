Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1AZUqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:46:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57413 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1AZUqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RHhF8H7CMg5JeJkw1Kqdi0qUPyhQy4XEQXsJ/SNfKM0DQuMxB0NBaW+zp8eizYVBQB
         Z69F1WUtvgVhn9oxfdFVVvBlFwwXNToOctmAIDox1RIoxFIWKeLV5ffkY/7VbBhltPFd
         JWyhwN97qC/lRDxctoIpQtSZJUVIRDbAxeBU8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101261534460.13169@p34.internal.lan>
References: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
	<AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
	<alpine.DEB.2.00.1101261534460.13169@p34.internal.lan>
Date: Wed, 26 Jan 2011 12:46:46 -0800
Message-ID: <AANLkTi=qAfFTqhaFO+n0gxtr2e_YeZpQ20RVeeHCrpPL@mail.gmail.com>
Subject: Re: 3w-sas 0000:02:00.0: vpd r/w failed.
From: adam radford <aradford@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:40 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> Does the driver require some combination of those options to be enabled? Or
> does the 3ware card need a firmware update?  What is the recommended fix?

Your config looks okay.  I remember you having some issues turning on
those config options in the past.

Perhaps under certain conditions occasionally the card cannot respond
in the default timeout period:

        unsigned long timeout = jiffies + HZ/20 + 2;

-Adam
