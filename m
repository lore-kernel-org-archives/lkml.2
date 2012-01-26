Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2AZQK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:10:57 -0500
Received: from nm18.access.bullet.mail.mud.yahoo.com ([66.94.237.219]:48145
	"HELO nm18.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751544Ab2AZQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:10:54 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 11:10:54 EST
X-Yahoo-Newman-Id: 858431.47600.bm@smtp109.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b63jKO8VM1mIqQirNVVpNaxvpfJIdH6KxC12o5soGh9G.6u
 .0JitmHsLpiZ_.Q8eo5L.xP6THoiO9Lq9lhDdm2svfEvUTV_I_.KtSshhG27
 MieWUJlTXa3fxyxlCprIUUO23GbNoTzirZgGVDE9jT0NyOIVK.IXpMA5Pb9T
 OYa6uYwPAdZJkv7jZpKTEAd8ZLnlLjBIAzz7IT_NEl1ZgfC6ydJA33XNUC6w
 JX_lKdmbnkkVzvPZa4KRC86C5zCb9gx4T5gUZdYla_ngUDigNPpTnR99DDDg
 HxeCRImn_qk3cjGIb0cq6OXRf3rAtGVgOO2_uHRfTnmBaLogHiJFngGOBfhw
 v5BmarRjtmpe6kByvfzSLq257HHDso86YOYAIqY88sFWZsA72fg.iM0.7ygt
 CLaRYYm5BrZ6cAG5sMnBzoxXQIl8i7CZ.68rAYOf63cdeUL2t9zgSUfQ7aKx
 abIGfzsHhfSn_QU7D1maNEYlIpw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F21798C.5040205@schaufler-ca.com>
Date: Thu, 26 Jan 2012 08:04:28 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        draht@suse.com, LSM <linux-security-module@vger.kernel.org>
Subject: Re: security_path hooks for xattr
References: <87fwf2y6mw.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87fwf2y6mw.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/2012 4:45 AM, Miklos Szeredi wrote:
> Forwarding from an internal bug report:
>
>     "AppArmor does not mediate the xattr system calls for confined processes.
>
>     As a consequence, a confined process can cross the confinement privilege
>     boundary by reading or writing to extended attributes that the confined
>     task should not have access to. The restrictions for security and user
>     attributes read and write still apply according to DAC; however, this
>     does not comply with the claim of AppArmor to mediate fipe
>     operations. The use of extended attributes is very flexible, so that the
>     effect of a missing mediation can lead to false assumptions in
>     subsequent policy decisions (eCryptfs)."
>
> AFAIU this boils down to missing security hooks in *xattr().
>
> Would it be possible to add these hooks?

Please post proposed patches to linux-security-module@vger.kernel.org


>
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

