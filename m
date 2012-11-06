Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2KFWsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:48:16 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48250 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2KFWsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:48:15 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
References: <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org> <87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org> <87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org> <87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de> <50992946.4060101@genband.com> <87625iwgao.fsf@mid.deneb.enyo.de> <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com> <20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Tue, 06 Nov 2012 17:47:25 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Florian Weimer <fw@deneb.enyo.de>,
        Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Message-ID: <a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.37.229
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, and scripts run as root can wipe your files too. That's really not what this is all about. 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
