Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0K3KfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:35:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58534 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0K3KfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rU+hSZGry+apRByNnsn2zTE3Bv8T7W2s0oOgy6CSDUMLG89zFQn3NvmVrOnGn84h55
         7GC7JqCj5H5ojMBvWfvOCoAxIe2FHhtYXFIXfek9z5E2eMRTppJfXb2nLlu0H1p/nPLX
         ygGCRL0o8vNfVAiBjKXxNEfgehTFhzwd9Fyi8=
MIME-Version: 1.0
In-Reply-To: <20101130060926.GA31838@core.coreip.homeip.net>
References: <matteo.dameno@st.com> <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
 <20101130060926.GA31838@core.coreip.homeip.net>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Tue, 30 Nov 2010 11:34:58 +0100
Message-ID: <AANLkTikpVtq2cQVhhcsJhZwGFW74mTqo=-vVK1e50AC2@mail.gmail.com>
Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mems applications <mems.applications@st.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, matteo.dameno@st.com,
        carmine.iascone@st.com, mems <mems@mems-laptopt43.corenet.prv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 7:09 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> +      If you say yes here you get support for the
>> +      STM LPS001D Barometer/Termometer on I2C bus.
>
> This does not belong to input subsystem, IIO is a better fit.

According to this site:
http://www.cnbc.com/id/40413317
and its datasheet:
http://www.findmems.com/wp-content/uploads/2010/11/LPS001WP-DATASHEET.pdf

This sensors applications are:
■ Altimeter and barometer for portable devices
■ Smartphones
■ Indoor navigation
■ GPS applications
■ Weather station equipment
■ Sports watches

"the same devices would be able to identify the precise location in
all three dimensions, allowing, for example, a mobile phone to send a
call to an emergency fire, medical or police service that identified
not only the location of the building but also the particular floor."
Identifying 3d location is similar to what many joystick are doing.

Specially the indoor navigation information means an information about
the user. And the information is very tied to the user.
I don't know whether this can be used to map with virtual reality in a
game, or where you use sensors data to give user informations when
visiting a museum.


Dmitry, is it possible to start putting similar drivers in a new
drivers/input/sensors directory but which belongs to the input
subsystem ? What do you think ?


i
