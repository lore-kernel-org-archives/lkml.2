Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2KFWob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:44:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2KFWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:44:28 -0500
Date: Tue, 6 Nov 2012 22:49:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Florian Weimer <fw@deneb.enyo.de>,
        Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
In-Reply-To: <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com>
	<20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com>
	<20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com>
	<20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
	<878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
	<87625iwgao.fsf@mid.deneb.enyo.de>
	<7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2012 16:55:25 -0500
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> I'm not sure why you think that Fedora PXE installs will automatically wipe disks - they'll do whatever Kickstart tells them to do. The only thing relevant to secure boot here is that you need a signed bootloader, just like when you book off CD. 

They'll do whatever the kickstart file says - which means for any
untrusted distribution path like PXE your kickstart file had better be
signed too
