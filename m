Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab0HLPbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:31:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56108 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0HLPba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r36KOU3/n9SN8MgfXmwuPHUlVQuSnu8kPFFsvyQsSfBxg4swWvkbgELuPPUYCoo9Cs
         IKMZ4YHQjfOPYUF6G+u2XzUVQgpByhUy82jrTf+9sFPBkO2YEXGlfsUOonIXnFYKBLDk
         FV3ppG4C9Qiq9JrnFNScQI+7YAj6WFZmib1No=
MIME-Version: 1.0
In-Reply-To: <20100812151226.GA21753@suse.de>
References: <AANLkTikK5m_DE_bzcuiqOpoSVqFzUp=GeD5k01foop=E@mail.gmail.com>
	<20100812151226.GA21753@suse.de>
Date: Thu, 12 Aug 2010 17:31:29 +0200
X-Google-Sender-Auth: 0Cdu5v1-TXgArD9dXnKXcgSnafE
Message-ID: <AANLkTikgddxg01_RfgZiNXf9PV2pmXRu5M7YRBbKBdLL@mail.gmail.com>
Subject: Re: [ANNOUNCE][UNOFFICIAL] 2.6.33.8
From: John Kacur <jkacur@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 5:12 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Aug 12, 2010 at 04:58:13PM +0200, John Kacur wrote:
>> There are no longer any official 2.6.33 stable releases after 2.6.33.7
>> However, 2.6.33.y is the basis for the real-time kernel.
>
> Why is the -rt kernel sticking with this older version?  Any specific
> reason to not move to .34 or at the least, .35?
>

Nope, just lack of manpower. We need to stabilize on a version, so we've been
working with .33. At some point, we'll move to the latest. We've been
skipping every
other kernel, but not by design, just chance.
