Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1APKGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 05:06:20 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51629 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1APKGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 05:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=StPM0LkZyMXzm2bnOrdfv3ZFvQnRzAymFeWOQnUJ8aRnwpn9egH/ZPlVeaZoIg/kgn
         N4dkPBv/lhKCKQ3D5AH32zY7Pwux7JsD39Mnb+nEH57z4hPBu0o4/MtlOjJ3dFc6eS0I
         +vH6v37Wt84Yy88+0gBkvxu3emoykh4nZcO9A=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Hans de Bruin <jmdebruin@xmsnet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bug in linux-2.6.37-rc8+: Weird X display upon hibernating
Date: Sun, 16 Jan 2011 11:06:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: Siddu <siddu.sjce@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTinCSu68cC_jzO8MZs4Q=u+EABiZxkRv3gbyfqMk@mail.gmail.com> <AANLkTin4yh3mQ7pbGPvYFNgNnRDVrmJUD4yUJT1tusC7@mail.gmail.com> <4D2B5C08.4010109@xmsnet.nl>
In-Reply-To: <4D2B5C08.4010109@xmsnet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101161106.11217.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 10 stycznia 2011 o 20:20:40 Hans de Bruin wrote:
> On 01/09/2011 06:07 PM, Siddu wrote:
> > seems like its not getting much attention here .... atleast can anyone
> > tell me which is the right place to be brought into notice ?
> 
> If you want to avoid the lkml you might want to look at buzilla. Rafael
> Wysocki has a list of bugs/regressions for each kernel release. The list
> for 2.6.37 is at:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=21782
> 
> If your problem is not there yet, you can add an entry.

Firstly you must sure, that _is_ regression. Siddu wrote: "Here is something 
strange which seems to happening with 2.6.37-rc8+
also i am not sure if this existed earlier ."

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
