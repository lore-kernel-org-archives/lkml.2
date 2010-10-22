Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0JVMbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:31:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60568 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0JVMba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DjUcr/yXClenAlmtlEYox7L3iUS3/vc2ZBQM5qgEoAv+cRMfApYhhDio7IA94XoVu1
         NxuQ/WUXotAUb0zdr5Lmxc22yqJHL5+K+kR7SRDqukDyljTzDmqvTFvipQi4+GC7MeLq
         Cw2gRRuWZLu3ITh7dvfmRfFyoRTxrwMVAaX3I=
MIME-Version: 1.0
In-Reply-To: <20101021165420.GA8718@sucs.org>
References: <20101016141321.GA11054@sucs.org>
	<20101017131016.GB13015@khazad-dum.debian.net>
	<20101017145025.GA32599@sucs.org>
	<201010172032.43206.rjw@sisk.pl>
	<20101021165420.GA8718@sucs.org>
Date: Fri, 22 Oct 2010 13:31:28 +0100
Message-ID: <AANLkTimJQN=SNCDwOJLo0MKXEcutTKZ3qd81hNAKeXGg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
From: Richard Hughes <hughsient@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2010 17:54, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> I guess there are a whole bunch of other attributes that could
> theoretically be -1 and shouldn't be used if they return it...

I think checking for <0 is probably a good idea, and I'm a little
surprised we don't do this already. Patch welcome, if this is what you
decide to do.

Richard.
