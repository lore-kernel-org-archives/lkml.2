Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1ASJmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:42:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62188 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1ASJmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LVowka5TfEzF6FRFosOHVTecWBWdmapAYI8n2ZGfxEZNBKQ4DqQH1iCsPPHe4E6Qz0
         I6rglyuvU79xOAyECGrQ/dEGqLNEO9jM9T89ofKV4JveSyFsk5xcfEOBlOAuj5GSWbnk
         TuYnZIaLreXew4IcafYnnFzoY73DUmSxA88hg=
MIME-Version: 1.0
In-Reply-To: <4D35FB33.1080305@genband.com>
References: <4D35FB33.1080305@genband.com>
Date: Wed, 19 Jan 2011 10:42:42 +0100
Message-ID: <AANLkTi=g-tSrLMmu4JuuKrze4SJD67CSmbS3aONBw7wV@mail.gmail.com>
Subject: Re: tool to send unsolicited neighbour advertisements?
From: Martin Volf <martin.volf.42@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 January 2011 21:42, Chris Friesen <chris.friesen@genband.com> wrote:
> We're transitioning stuff to IPv6 and I've been trying (without much
> luck) to find a standard tool for sending out unsolicited neighbour
> advertisements for failover purposes.
> Is there such a thing?  In ipv4 arping works fine.

Hello,

probably http://www.remlab.net/ndisc6/

-- 
Martin Volf
