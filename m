Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2DRW65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:58:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47038 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2DRW6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F3909.2050706@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
	<4F8EFE4D.2040201@zytor.com>
	<CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com>
	<4F8F0385.5090901@zytor.com>
	<CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
	<4F8F0614.9010604@zytor.com>
	<CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
	<4F8F30F5.9030704@zytor.com>
	<CAMe9rOpPStV7+3hSMifVGcRXwF+X_DzjxgUCPBn_nSWyJiOYfg@mail.gmail.com>
	<4F8F3909.2050706@zytor.com>
Date: Wed, 18 Apr 2012 15:58:54 -0700
Message-ID: <CAMe9rOrpCWk9yQX=Bs1Cm4XzN85CX6qh=Zjf52g74ghTcdmLpQ@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 2:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/18/2012 02:49 PM, H.J. Lu wrote:
>>
>> I think you mentioned to me about this. Have you opened a gcc bug to
>> request to this feature?
>>
>
> I have not, I don't think.  I thought you said you would do it, but
> maybe I misremember.
>

I opened:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=53037

-- 
H.J.
