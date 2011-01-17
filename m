Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1AQVXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:23:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58628 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1AQVXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xFFVNUqg1GzCjYU7qdA0tP1naOUTmIwmSVwrv0mR/Ha6qZ7S0kLP50Ne3sDcsb5U1C
         QG6YbFtL4tKxrxAzUXrD3mcbQlaSFvfLPicXCBFnhnijIicOOLC1ePZllrZeOy/EoSRw
         i+OV6Lwg/Rm2Cssyw39AuQhsqnuCW87WQNopY=
MIME-Version: 1.0
In-Reply-To: <20110117083208.GA7569@ff.dom.local>
References: <AANLkTinHOFwPCwJNCy9cFMCf+_VNb-7YFk-3VJFXoaoZ@mail.gmail.com>
	<20110117083208.GA7569@ff.dom.local>
Date: Mon, 17 Jan 2011 22:23:18 +0100
Message-ID: <AANLkTikF4HtXzvyiST72t4XE14sjCX-27CLLWvsF8D5o@mail.gmail.com>
Subject: Re: NETLINK: Failed to browse: Invalid argument from avahi-daemon in
 F14 since 2.6.37-git8
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 9:32 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On 2011-01-15 19:34, Alessandro Suardi wrote:
>> /var/log/messages says:
>>
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Found user 'avahi' (UID 70)
>> and group 'avahi' (GID 70).
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped root privileges.
>> Jan 13 12:42:02 duff avahi-daemon[2771]: avahi-daemon 0.6.27 starting up.
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully called chroot().
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Successfully dropped remaining capabilities.
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file /services/ssh.service.
>> Jan 13 12:42:02 duff avahi-daemon[2771]: Loading service file /services/udisks.service.
>> Jan 13 12:42:02 duff avahi-daemon[2771]: NETLINK: Failed to browse: Invalid argument
>> Jan 13 12:42:23 duff acpid: starting up with netlink and the input layer
>>
>>
>> Happens both at boot and after boot if restarting avahi-daemon service,
>>  and there is a 10-15" wait before the service start script prints a [FAILED]
>>  red tag; avahi-daemon process does start up anyways.
>>
>> -git7 is the latest "good" kernel
>> -git8, -git9, -git11, -git13 have been reproducing the issue
>>
>>
>> thanks, ciao,
>
> Seems to be resolved in this thread:
>
> http://www.spinics.net/lists/netdev/msg152762.html

Thanks Jarek - filed Fedora bug 670316 for this one.

https://bugzilla.redhat.com/show_bug.cgi?id=670316

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
