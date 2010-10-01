Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0JALa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:30:57 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34721 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0JALaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IfmVBG3I18OwvsyS45nak08pv1KA+35Cag4NL026GmnRf481M/VsAR81PUp1EIYyDF
         HBDONX/12wIlwej1YbffziixMUnA+ModVXN2OQ4f5irBYUR/4XxQ88uB9DcqepyAEG1T
         HXkikqb7BcPZW5umx0xThFQCaBgjiATOcc/lE=
MIME-Version: 1.0
In-Reply-To: <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
Date: Fri, 1 Oct 2010 07:30:54 -0400
Message-ID: <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
Subject: Re: Introduce support for little endian PowerPC
From: Josh Boyer <jwboyer@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 5:02 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Oct 1, 2010, at 2:05 AM, Ian Munsie wrote:
>
>> Some PowerPC processors can be run in either big or little endian modes, some
>> others can map selected pages of memory as little endian, which allows the same
>> thing. Until now we have only supported the default big endian mode in Linux.
>> This patch set introduces little endian support for the 44x family of PowerPC
>> processors.
>
> From a community aspect is anyone actually going to use this?  Is this going to be the equivalent of voyager on x86?  I've got nothing against some of the endian clean ups this introduces.  However the changes to misc_32.S are a bit ugly from a readability point of view.  Just seems like this is likely to bit-rot pretty quickly.

I'm with Kumar on this one.  Why would we want to support this?  I
can't say I would be very willing to help anyone run in LE mode, let
alone have it randomly selectable.

josh
