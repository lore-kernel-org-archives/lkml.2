Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab0FJR5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:57:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759123Ab0FJR5A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <4C11223E.7010806@redhat.com>
References: <4C10B10D.80304@redhat.com>
	<AANLkTilIIesuFHNVBhpeOe3XiJ5JDDIxt2wLH9MzyF_e@mail.gmail.com>
	<4C11223E.7010806@redhat.com>
Date: Thu, 10 Jun 2010 10:56:53 -0700
Message-ID: <AANLkTik3QT6A1Y8PcAAz2tC7BfMP6NBIzYh9hhdC_kEa@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for 2.6.35-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 10:34 AM, Avi Kivity <avi@redhat.com> wrote:
>
> Ok.  I've dropped the SRAO patch; this still leaves ~100 changed lines, but
> they are almost all due to the erratum 383 workaround, which can result in a
> guest killing the host.  The rest of the patches are less critical, but they
> are one liners and I am comfortable with them in -rc3.  The new diffstat
> also shows no changes to core code:

Ok. Pulled the updated version. Thanks,

                  Linus
