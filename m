Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0EZRu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:50:56 -0400
Received: from earth.cora.nwra.com ([65.44.101.180]:43930 "EHLO
	earth.cora.nwra.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0EZRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:50:55 -0400
Message-ID: <4BFD5F71.3000306@cora.nwra.com>
Date: Wed, 26 May 2010 11:50:41 -0600
From: Orion Poplawski <orion@cora.nwra.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com> <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
In-Reply-To: <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:31 AM, Alexander Graf wrote:
>
> Do you have ntpd running inside the guest? I have a bug report lying around about 2.6.33 with kvm-clock jumping in time when ntpd is used: https://bugzilla.novell.com/show_bug.cgi?id=582260
>
> Alex
>

I've used ntpd and chronyd.  I haven't tried running without either.  I'll do 
that now...


-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA/CoRA Division                    FAX: 303-415-9702
3380 Mitchell Lane                  orion@cora.nwra.com
Boulder, CO 80301              http://www.cora.nwra.com
