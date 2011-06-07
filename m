Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1FGMWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:22:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56085 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FGMWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uqIvK9+nZpiqd2d0aKzoqWjqIzQG1EtAHowez0byjnr3f2SXBQdr/RjjPcRhuWMD1i
         1h0CgoB4ZnoopEvZrf8aTnaLfPOI57GKs33wUo/ALt26qJzgeu6ixJ3gNxoHAsnf9LL9
         JyiOLQ8Wb9ZdXFm+PLeExg4wKiH8AIEk9ZtJk=
Date: Tue, 7 Jun 2011 20:22:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: Re: [Patch] doc: remove ns_cgroup from feature-removal-schedule.txt
Message-ID: <20110607122233.GB3550@cr0>
References: <20110607120630.GA3550@cr0>
 <4DEE1753.2060307@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DEE1753.2060307@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 02:19:31PM +0200, Daniel Lezcano wrote:
>On 06/07/2011 02:06 PM, Américo Wang wrote:
>>In the following commit Daniel removed ns_cgroup
>>
>>	commit a77aea92010acf54ad785047234418d5d68772e2
>>	Author: Daniel Lezcano<daniel.lezcano@free.fr>
>>	Date:   Thu May 26 16:25:23 2011 -0700
>>
>>	    cgroup: remove the ns_cgroup
>>
>>but Daniel forgot to remove the related doc in feature-removal-schedule.txt.
>>This patch removes that too.
>
>Well, I am not sure we should remove this entry from the documentation.

That is a list of features which will be removed,
not for features that was in the kernel.

>I let this in the doc because people may want to follow what was
>removed and from what kernel version.

We have changelogs or git logs, right? :)

>Looking at the doc, there are a lot of old entries.

Such as?
