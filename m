Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2KEScT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:32:19 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:44968 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530Ab2KEScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:32:17 -0500
Date: Mon, 5 Nov 2012 10:32:15 -0800 (PST)
From: George Zhang <georgezhang@vmware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        davem@davemloft.net, gregkh@linuxfoundation.org
Message-ID: <854640502.31217031.1352140335740.JavaMail.root@vmware.com>
In-Reply-To: <CA+1xoqcMo1RrJKAaS+k5cVuRonRF+go7tJKUkARP_xcuZAwoGw@mail.gmail.com>
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2674 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha,
There is a 'brief' implementation notes aboutVSOCK protocol family
in af_vsock.c. More about user space layer socket programming is from
VMCI Socket Programming Guide. (remove crosstalk@vmware.com for email bouncing).
thanks,
George

----- Original Message -----
From: "Sasha Levin" <levinsasha928@gmail.com>
To: "George Zhang" <georgezhang@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pv-drivers@vmware.com, vm-crosstalk@vmware.com, davem@davemloft.net, gregkh@linuxfoundation.org
Sent: Monday, November 5, 2012 10:23:02 AM
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming

Hi George,

On Mon, Nov 5, 2012 at 1:00 PM, George Zhang <georgezhang@vmware.com> wrote:
> For additional information about the use of VMCI and in particular
> VMCI Sockets, please refer to the VMCI Socket Programming Guide
> available at https://www.vmware.com/support/developer/vmci-sdk/.

Is there documentation about the protocol itself? I couldn't find it
on the link above.


Thanks,
Sasha
