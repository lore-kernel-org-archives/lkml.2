Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab0FIEZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 00:25:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65179 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0FIEZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 00:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vso9/7nTultvmnKHbx7uj6T5CNY5KYtAQ1Z61nwxfDQdP7W6I/+tRaUVqp23FpdQZG
         3hWh0nqdE2KDSopyCuAcx21BlHOTbSd8sh/vwuwqtbDN2fvvbbJuNb4sdpPhWbuUULd0
         ePQM7eE99NwILqmdLGWLPfwLo3b2uKGZkLP4E=
MIME-Version: 1.0
In-Reply-To: <AANLkTin5kMu_ScK8qYcm2r3TrwgnQM9EGiOU3vNboQXu@mail.gmail.com>
References: <AANLkTin5kMu_ScK8qYcm2r3TrwgnQM9EGiOU3vNboQXu@mail.gmail.com>
Date: Wed, 9 Jun 2010 07:25:19 +0300
Message-ID: <AANLkTimfVYljvN8BF9dHZC_GJHu-GjLcrCACa0LhlxIg@mail.gmail.com>
Subject: Re: Submitting through GIT
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 6:52 AM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> If I wanted to submit MDB through GIT for testing or inclusion, how
> would I do that, or am I even allowed to?  MDB is small and modular
> and I am almost finished with X86_64.  It's also an assembler debugger
> for us old dos heads.  I guess the real question is if it ended up
> there I'd have to be around to support it forever.  No problem.
...

Hi, Jeffrey !

Please see how Tilera arch got included in linux-next.
First, prezent a link to your tree.
After you receive some pozitive reviews, ask Stephen Rothwell to
include it in next.
When you are ready ask Linus directly, or an mantainer to pull it in
the merge window.
